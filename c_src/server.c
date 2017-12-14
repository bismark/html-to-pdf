#include <stdbool.h>
#include <stdio.h>
#include <wkhtmltox/pdf.h>

void error(wkhtmltopdf_converter * c, const char * msg) {
    fprintf(stderr, "Error: %s\n", msg);
}

void processLine(char *lineBuffer) {
    static char fromFilePath[4096];
    static char toFilePath[4096];
    if (2 != sscanf(lineBuffer, "%s %[^\n]s", fromFilePath, toFilePath)) {
        fprintf(stderr, "ERROR bad_input\n");
        return;
    }

    wkhtmltopdf_global_settings * gs;
    wkhtmltopdf_object_settings * os;
    wkhtmltopdf_converter * c;

    gs = wkhtmltopdf_create_global_settings();
    wkhtmltopdf_set_global_setting(gs, "out", toFilePath);
    wkhtmltopdf_set_global_setting(gs, "size.pageSize", "Letter");

    os = wkhtmltopdf_create_object_settings();
    wkhtmltopdf_set_object_setting(os, "page", fromFilePath);
    wkhtmltopdf_set_object_setting(os, "useExternalLinks", "false");
    wkhtmltopdf_set_object_setting(os, "web.enableJavascript", "false");
    wkhtmltopdf_set_object_setting(os, "load.blockLocalFileAccess", "false");
    wkhtmltopdf_set_object_setting(os, "load.loadErrorHandling", "ignore");

    c = wkhtmltopdf_create_converter(gs);
    wkhtmltopdf_set_error_callback(c, error);
    wkhtmltopdf_add_object(c, os, NULL);
    if (wkhtmltopdf_convert(c)) {
        fprintf(stdout, "OK\n");
    }
    else {
        fprintf(stderr, "ERROR conversion_failed\n");
    }
    wkhtmltopdf_destroy_converter(c);
}

int main() {
    if (!wkhtmltopdf_init(false)) {
        return 1;
    }

    static char lineBuffer[4096];
    while (fgets(lineBuffer, 4096, stdin)) {
        processLine(lineBuffer);
    }

    wkhtmltopdf_deinit();
    return 0;
}
