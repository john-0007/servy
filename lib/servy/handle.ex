defmodule Servy.Handle do
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end


  def parse(conv) do

  end

  def route(conv) do

  end
  def format_response(conv) do

  end
end
