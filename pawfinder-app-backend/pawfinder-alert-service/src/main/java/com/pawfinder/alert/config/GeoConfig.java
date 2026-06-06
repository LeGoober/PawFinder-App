package com.pawfinder.alert.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

/**
 * GeoConfig sets up Hibernate Spatial / JTS integration.
 * With Hibernate 6, the dialect handles POINT/GEOGRAPHY mapping automatically
 * when the hibernate-spatial dependency is on the classpath.
 */
@Configuration
public class GeoConfig {

    /**
     * ObjectMapper configured with Java 8 date/time support
     * for serializing/deserializing LocalDateTime, etc.
     */
    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        return mapper;
    }
}
