defmodule Dotor.Captcha.Get do
  @moduledoc """
  Manda el captcha al cliente
  send the captcha to the client
  """
  def get_captcha(conn) do
    alias Dotor.Controllers.Response, as: Resp
    require Logger
    ip = Dotor.Utils.RemoteIp.get(conn)
    random_word = for _ <- 1..6, into: "", do: <<Enum.random('012345689abcdefg')>>
    # Crea la imagen
    # guarda la imagen
    # https://dotor-captcha-api.elpanajose.repl.co/?ip=#{ip}&word=#{random_word}
    # :os.cmd('python3 lib/utils/captcha_images_generator.py --i #{ip} -w #{random_word} ; mv *.png lib/utils/captcha_images')

    %HTTPoison.Response{body: body} =
      HTTPoison.get!("#{System.get_env("CAPTCHA_URI")}?ip=#{ip}&word=#{random_word}")

    File.write!("lib/utils/captcha_images/#{ip}.png", body)

    {:ok, conne} =
      Mongo.start_link(
        url: System.get_env("MONGO_URI"),
        pool_size: 3,
        username: System.get_env("MONGO_USER"),
        password: System.get_env("MONGO_PASS")
      )

    Logger.info "----ok #{ip}----" do
      data_to_insert = %{
        "word" => random_word,
        "ip" => ip,
        "solved" => false
      }

      ## insert the data
      # Sí, ip es el nombre de la db
      Mongo.insert_one(conne, ip, data_to_insert)

      Resp.send_file(
        conn,
        200,
        "lib/utils/captcha_images/#{ip}.png"
      )

      # Cerrar la conexión
      Dotor.Database.StopConnection.stop(conne)
    end
  end
end
