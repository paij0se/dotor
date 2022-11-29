defmodule Dotor.Get.GetPosts do
  @moduledoc """
   Get the posts
  """
  def get(conn) do
    alias Dotor.Controllers.Response, as: Resp

    {:ok, conne} =
      Mongo.start_link(
        url: System.get_env("MONGO_URI"),
        username: System.get_env("MONGO_USER"),
        password: System.get_env("MONGO_PASS")
      )

    # db.data.find().sort({$natural:-1});

    cursor = Mongo.find(conne, "data", %{}, sort: %{_id: -1})

    Resp.send_resp(
      conn |> Resp.put_resp_content_type("application/json"),
      200,
      Jason.encode!(
        cursor
        |> Enum.map(&Map.take(&1, ["text", "user_id", "posted_at", "post_id", "name"]))
      )
    )

    # Stop connecion
    Mongo.Topology.stop(conne)
  end
end
