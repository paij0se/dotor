defmodule Dotor.Controllers.Response do
  alias Plug.Conn, as: Conn

  @moduledoc """
  This module it works for made it more easy to maintain
  and change the frameworks and stuff
  `send_resp` and `send_file` are only for made more easy that
  and render its for render the EEx files.
  besides that i have nothing to say
  """
  @spec send_resp(Plug.Conn.t(), integer, binary) :: Plug.Conn.t()
  def send_resp(conn, status, value) do
    conn |> Conn.send_resp(status, value)
  end

  def put_resp_content_type(conn, header) do
    conn |> Conn.put_resp_content_type(header)
  end

  @spec send_file(Plug.Conn.t(), integer, binary) :: Plug.Conn.t()
  def send_file(conn, status, path) do
    conn |> Conn.send_file(status, path)
  end
end
