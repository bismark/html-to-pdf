defmodule HtmlToPdf do

  def convert(from_file, to_file) do
    HtmlToPdf.Khtml.convert(from_file, to_file)
  end

end
