defmodule HtmlToPdf do

  def convert(from_file, to_file) do
    HtmlToPdf.Khtml.convert(from_file, to_file)
  end


  def run do
    Enum.each([1,10,20], fn iterations ->
      IO.ANSI.format([IO.ANSI.color(1,1,5), "Iterations", :default_color, ": #{iterations}"])
        |> IO.puts
      IO.puts "Doing Worker..."
      worker_res = do_test(:worker, iterations)
      IO.puts "Doing Fork..."
      fork_res = do_test(:fork, iterations)
      IO.puts "Worker: #{worker_res}ms"
      IO.puts "Fork: #{fork_res}ms"
      IO.puts "Difference: #{fork_res - worker_res}ms"
      percentage = Float.round(100 - worker_res/fork_res * 100, 2)
      IO.ANSI.format([IO.ANSI.color(1,5,1), "Speed up", :default_color, ": ", IO.ANSI.color(5,1,1), "#{percentage}", :default_color, "%"])
        |> IO.puts
    end)
  end


  def do_test(version, iterations \\ 10) do
    File.rm_rf("output")
    File.rm_rf("input")
    File.mkdir("output")
    File.mkdir("input")
    files = for i <- 1..iterations do
      from_file = Path.expand("input/test-#{i}.html", System.cwd)
      to_file = Path.expand("output/test-#{i}.pdf", System.cwd)
      File.copy("test.html", from_file)
      {from_file, to_file}
    end

    res = case version do
      :fork ->
        start = System.monotonic_time()
        res = Task.async_stream(files, &fork/1, timeout: :infinity)
        Enum.to_list(res)
        stop = System.monotonic_time()
        System.convert_time_unit(stop - start, :native, :milliseconds)
      :worker ->
        start = System.monotonic_time()
        res = Task.async_stream(files, fn ({from_file, to_file}) ->
          HtmlToPdf.Khtml.convert(from_file, to_file)
        end, timeout: :infinity)
        Enum.to_list(res)
        stop = System.monotonic_time()
        System.convert_time_unit(stop - start, :native, :milliseconds)
    end

    File.rm_rf("output")
    File.rm_rf("input")
    res
  end


  def fork({from_file, to_file}) do
    options = [
      "--disable-javascript",             # Don't run JS
      "--disable-external-links",         # Don't render links to external locations in the resulting PDF
      "--disable-local-file-access",      # Disable access to local file
      "--load-error-handling",            # Ignore network issues
      "ignore",
      "--page-size",                      # Use US Letter instead of default A4
      "Letter",
      from_file,                      # Path to the HTML file to convert
      to_file,                        # Output path
    ]

    System.cmd("wkhtmltopdf", options, stderr_to_stdout: true, parallelism: false)
    :ok
  end

end
