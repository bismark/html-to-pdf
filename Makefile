CC = gcc
CFLAGS =
LDFLAGS = -lwkhtmltox -Wall -pedantic -ggdb
SOURCE_FILES = c_src/wkhtmltopdf-server.c
OBJECT_FILES = $(SOURCE_FILES:.c=.o)
	EXECUTABLE_DIRECTORY = priv/bin
	EXECUTABLE = $(EXECUTABLE_DIRECTORY)/wkhtmltopdf-server

all: $(SOURCE_FILES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECT_FILES) $(EXECUTABLE_DIRECTORY)
		$(CC) $(OBJECT_FILES) -o $@ $(LDFLAGS)

$(EXECUTABLE_DIRECTORY):
		mkdir -p $(EXECUTABLE_DIRECTORY)

.o:
		$(CC) $(CFLAGS) $< -o $@

clean:
		rm -f $(EXECUTABLE) $(OBJECT_FILES)

