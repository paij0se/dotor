defmodule Dotor.Captcha.Post do
  @moduledoc """
  verify if the captcha is correct
  """
  def post_captcha(conn) do
    require Logger
    alias Dotor.Controllers.Response, as: Resp

    ip = Dotor.Utils.RemoteIp.get(conn)

    word =
      case conn.body_params do
        %{"word" => w} -> w
        _ -> ""
      end

    Logger.info([word])
    # Devolver un valor booleano si paso el capcha
    # -> true: valido
    # -> false: invalido
    {:ok, conne} =
      Mongo.start_link(
        url: System.get_env("MONGO_URI"),
        username: System.get_env("MONGO_USER"),
        password: System.get_env("MONGO_PASS")
      )

    # busca esa monda
    cursor = Mongo.find_one(conne, ip, %{}, sort: %{_id: -1})
    # checa si la palabra del captcha es la que esta en la base de datos
    Logger.info([word, " ??? ", cursor["word"]])

    if word == cursor["word"] do
      # Si esta correcta la palabra

      # cambiar a solved => true
      # Se borra todo
      Mongo.drop_collection(conne, "#{ip}")
      # Se vuelve a crear esa monda pero esta vez con true
      data_to_insert = %{
        "word" => word,
        "ip" => ip,
        "solved" => true
      }

      ## insert the data
      Mongo.insert_one(conne, ip, data_to_insert)
      # Stop cooanfjlfl...
      Mongo.Topology.stop(conne)
      Resp.send_resp(
        conn |> Resp.put_resp_content_type("application/json"),
        200,
        Jason.encode!("ok")
      )
    else
      Resp.send_resp(
        conn |> Resp.put_resp_content_type("application/json"),
        200,
        Jason.encode!("no es correcto el captcha")
      )
    end
  end
end
