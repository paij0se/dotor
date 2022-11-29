defmodule Dotor.Router do
  @moduledoc """
  Las rutas de dotor
  """
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  import Plug.Conn
  plug(RemoteIp)
  plug(:match)
  require Logger

  plug(CORSPlug)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    send_resp(
      conn |> put_resp_content_type("application/json"),
      200,
      "Hola, Dotor!"
    )
  end

  get "/api/v1/get/captcha" do
    Dotor.Captcha.Get.get_captcha(conn)
  end

  post "/api/v1/post/captcha" do
    Dotor.Captcha.Post.post_captcha(conn)
  end

  post "/api/v1/post" do
    Dotor.Post.PostText.post(conn)
  end

  ## Get the data
  get "/api/v1/get/" do
    Dotor.Get.GetPosts.get(conn)
  end

  # por si se va a una ruta que no existe
  match _ do
    send_resp(
      conn |> put_resp_content_type("application/json"),
      404,
      Jason.encode!(%{error: "error"})
    )
  end
end
