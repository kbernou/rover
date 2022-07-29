defmodule Rover.GenRover do
  use GenServer

  # {max_x, max_y, [{id, x , y},...]} state of genserver [rover]
  # {:dir, rover_id}
  def init(state) do
    {:ok, state}
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def move(pid, data) do
    GenServer.call(pid, data)
  end

  def handle_call({dir, rover_id}, _from, {max_x, max_y, rovers}) do
    # find rover element in state
    # attempt to move it in the direction
    # if another rover is there, nope
    # if it goes past the border, nope
    # update state, indicating if there was movement
    # done

    rover = Enum.find(rovers, fn {id,_,_} -> id == rover_id end)

    case can_move(dir, rover, rovers) do
      true -> move_rover(dir, rover)
      false -> {:blocked, rover}
    end


  end

  defp can_move(:north, {_,current_x,current_y}, rovers) do
    !Enum.find(rovers, true, fn {_,x,y} -> x == current_x && y == current_y+1 end)
  end

  defp can_move(:south, {_,current_x,current_y}, rovers) do
    !Enum.find(rovers, true, fn {_,x,y} -> x == current_x-1 && y == current_y end)
  end

  defp can_move(:east, {_,current_x,current_y}, rovers) do
    !Enum.find(rovers, true, fn {_,x,y} -> x == current_x+1 && y == current_y end)
  end

  defp can_move(:west, {_,current_x,current_y}, rovers) do
    !Enum.find(rovers, true, fn {_,x,y} -> x == current_x-1 && y == current_y end)
  end

  defp move_rover(dir, {id, x, y}) do
    case dir do
      :north -> {:ok, {id, x+1, y}}
      :south -> {:ok,{id, x-1, y}}
      :east -> {id, x, y+1}
      :est -> {id, x, y-1}
    end
  end

end
