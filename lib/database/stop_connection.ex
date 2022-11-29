defmodule Dotor.Database.StopConnection do
  @spec stop(atom | pid | {atom, any} | {:via, atom, any}) :: :ok
  def stop(conne) do
    require Logger
    Process.sleep(1000)
    Mongo.Topology.stop(conne)
    Logger.info(["Conexión con la base de datos cerrada."])
  end
end
