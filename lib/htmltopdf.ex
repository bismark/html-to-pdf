defmodule HtmlToPdf do

  def convert(from_file, to_file) do
    HtmlToPdf.Pool.convert(from_file, to_file)
  end

end
