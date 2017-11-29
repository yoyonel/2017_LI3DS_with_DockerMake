#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <nmea.h>
#include <nmea/gpgll.h>
#include <nmea/gpgga.h>
#include <nmea/gprmc.h>

void parse_nmea_gpgll(nmea_s *data) {
    nmea_gpgll_s *gpgll = (nmea_gpgll_s *) data;

    printf("GPGLL Sentence\n");
    printf("Longitude:\n");
    printf("  Degrees: %d\n", gpgll->longitude.degrees);
    printf("  Minutes: %f\n", gpgll->longitude.minutes);
    printf("  Cardinal: %c\n", (char) gpgll->longitude.cardinal);
    printf("Latitude:\n");
    printf("  Degrees: %d\n", gpgll->latitude.degrees);
    printf("  Minutes: %f\n", gpgll->latitude.minutes);
    printf("  Cardinal: %c\n", (char) gpgll->latitude.cardinal);
}

void parse_nmea_gprmc(nmea_s *data) {
    printf("GPRMC sentence\n");
    nmea_gprmc_s *pos = (nmea_gprmc_s *) data;
    printf("Longitude:\n");
    printf("  Degrees: %d\n", pos->longitude.degrees);
    printf("  Minutes: %f\n", pos->longitude.minutes);
    printf("  Cardinal: %c\n", (char) pos->longitude.cardinal);
    printf("Latitude:\n");
    printf("  Degrees: %d\n", pos->latitude.degrees);
    printf("  Minutes: %f\n", pos->latitude.minutes);
    printf("  Cardinal: %c\n", (char) pos->latitude.cardinal);
    char buf[255];
    strftime(buf, sizeof(buf), "%H:%M:%S", &pos->time);
    printf("Time: %s\n", buf);
}

int main(void)
{
    // Sentence string to be parsed
    // char *sentence = strdup("$GPGLL,4916.45,N,12311.12,W,225444,A\n\n");
    //    char *sentence = strdup("$GPRMC,000001,A,4901.00,N,200.00,W,0.1,180,01012016,,,S*6C\n\n");
    char *sentence = strdup("$GPRMC,000003,A,4901.00,N,200.00,W,0.1,180,01012016,,,S*6E\n\n");

    const size_t strlen_sentence = strlen(sentence);

    printf("Parsing NMEA sentence: %s\n", sentence);
    printf("Type of sentence: %d\n", nmea_get_type(sentence));
    printf("Has a checksum: %s - %d\n",
           nmea_has_checksum(sentence, strlen_sentence) == 0 ? "True" : "False",
           nmea_get_checksum(sentence));
    printf("Validate sentence: %s\n",
           nmea_validate(sentence,
                         strlen(sentence),
                         nmea_has_checksum(sentence, strlen_sentence)
                         ) == 0 ? "True" : "False"
           );
    // Pointer to struct containing the parsed data. Should be freed manually.
    nmea_s *data;

    // Parse...
    data = nmea_parse(sentence,
                      strlen_sentence,
                      nmea_has_checksum(sentence, strlen_sentence) == 0);

    if (data) {
        if (NMEA_GPGLL == data->type)
            parse_nmea_gpgll(data);
        else if (NMEA_GPRMC == data->type)
            parse_nmea_gprmc(data);

        nmea_free(data);
    }

    free(sentence);

    return 0;
}
