defmodule HtmlToPdf.Khtml do
  def convert(from_file, to_file) do
    HtmlToPdf.Khtml.Pool.convert(from_file, to_file)
  end
end
