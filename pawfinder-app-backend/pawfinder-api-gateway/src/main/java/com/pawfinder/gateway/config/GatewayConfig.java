package com.pawfinder.gateway.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import static org.springframework.cloud.gateway.filter.factory.RewritePathGatewayFilterFactory.REGEXP_KEY;
import static org.springframework.cloud.gateway.filter.factory.RewritePathGatewayFilterFactory.REPLACEMENT_KEY;

@Configuration
public class GatewayConfig {

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // Auth Service
                .route("auth-service", r -> r
                        .path("/api/v1/auth/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("authCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/auth")))
                        .uri("http://localhost:8081"))

                // Alert Service
                .route("alert-service", r -> r
                        .path("/api/v1/alerts/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("alertCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/alert")))
                        .uri("http://localhost:8082"))

                // Sighting Service
                .route("sighting-service", r -> r
                        .path("/api/v1/sightings/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("sightingCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/sighting")))
                        .uri("http://localhost:8082"))

                // Pet Service
                .route("pet-service", r -> r
                        .path("/api/v1/pets/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("petCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/pet")))
                        .uri("http://localhost:8082"))

                // Messaging Service — Conversations
                .route("conversation-service", r -> r
                        .path("/api/v1/conversations/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("conversationCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/conversation")))
                        .uri("http://localhost:8083"))

                // Messaging Service — Messages
                .route("message-service", r -> r
                        .path("/api/v1/messages/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("messageCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/message")))
                        .uri("http://localhost:8083"))

                // Reward Service
                .route("reward-service", r -> r
                        .path("/api/v1/rewards/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("rewardCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/reward")))
                        .uri("http://localhost:8084"))

                // Media Service
                .route("media-service", r -> r
                        .path("/api/v1/media/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("mediaCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/media")))
                        .uri("http://localhost:8085"))

                // Analytics/Dashboard Service
                .route("dashboard-service", r -> r
                        .path("/api/v1/dashboard/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("dashboardCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/dashboard")))
                        .uri("http://localhost:8086"))

                // Leaderboard Service
                .route("leaderboard-service", r -> r
                        .path("/api/v1/leaderboard/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("leaderboardCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/leaderboard")))
                        .uri("http://localhost:8086"))

                // Badges Service
                .route("badge-service", r -> r
                        .path("/api/v1/badges/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/api/v1/${segment}")
                                .circuitBreaker(config -> config
                                        .setName("badgeCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/badge")))
                        .uri("http://localhost:8086"))

                // WebSocket
                .route("websocket-service", r -> r
                        .path("/ws/**")
                        .filters(f -> f
                                .circuitBreaker(config -> config
                                        .setName("wsCircuitBreaker")
                                        .setFallbackUri("forward:/fallback/ws")))
                        .uri("ws://localhost:8083"))

                .build();
    }
}
