package com.example.api.config;

import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;

@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "Engineering Foundation API",
        version = "v1",
        description = "Minimal API contract for engineering foundation"
    )
)
public class OpenApiConfig {

}
