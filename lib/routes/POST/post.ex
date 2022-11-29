defmodule Dotor.Post.PostText do
  @moduledoc """
  Post the text
  """
  def post(conn) do
    require Logger
    alias Dotor.Controllers.Response, as: Resp

    # Primero toca verificar si solved = true
    {:ok, conne} =
      Mongo.start_link(
        url: System.get_env("MONGO_URI"),
        pool_size: 3,
        username: System.get_env("MONGO_USER"),
        password: System.get_env("MONGO_PASS")
      )

    ip = Dotor.Utils.RemoteIp.get(conn)
    # Como solo va a estar el verdadero ponemos find
    verify = Mongo.find(conne, "#{ip}", %{}, sort: %{_id: -1})
    a = verify |> Map.get(:docs)
    b = Enum.at(a, 0)
    # si esta resulto
    if b["solved"] == true do
      Logger.info(["aja"])

      text =
        case conn.body_params do
          %{"text" => a_name} -> a_name
          _ -> ""
        end

      name =
        case conn.body_params do
          %{"name" => name} -> name
          _ -> ""
        end

      # limite de caracteres
      # TODO: Rate limit y conectar con mongo atlas. (ya)
      if byte_size(text) > 818 or byte_size(text) == 0 or byte_size(name) == 0 or
           byte_size(name) > 32 do
        conn
        |> Resp.put_resp_content_type("application/json")
        |> Resp.send_resp(400, Jason.encode!(["error", "Only allowed 818 characters or less and 32 characters for the name!"]))
      else
        ip = Dotor.Utils.RemoteIp.get(conn)
        # el id_user es la ip encriptada
        user_id = :crypto.hash(:sha, ip) |> Base.encode16() |> String.downcase()
        date = DateTime.utc_now() |> DateTime.to_unix()
        # El post_id es la ip + date.now (en unixtime)

        post_id =
          :crypto.hash(:sha, ip <> to_string(date)) |> Base.encode16() |> String.downcase()

        response = %{
          "user_id" => user_id,
          "text" => text,
          "posted_at" => date,
          "post_id" => post_id,
          "name" => name
        }

        # Esto es lo que se guarda en la DB
        data_to_insert = %{
          "user_id" => user_id,
          "text" => text,
          "ip" => ip,
          "posted_at" => date,
          "post_id" => post_id,
          "name" => name
        }

        ## insert the data
        Mongo.insert_one(conne, "data", data_to_insert)

        Resp.send_resp(
          conn |> Resp.put_resp_content_type("application/json"),
          200,
          Jason.encode!(response)
        )

        Logger.info(["New post!", Jason.encode!(data_to_insert)])
      end
    else
      # Si no esta resuelto
      conn
      |> Resp.put_resp_content_type("application/json")
      |> Resp.send_resp(
        400,
        Jason.encode!(["cerror", "No has resuelto el Captcha, o simplemente un bug"])
      )
    end

    # borrar toda esa monda para que le vuelva a pedir
    Mongo.drop_collection(conne, "#{ip}")
  end
end
