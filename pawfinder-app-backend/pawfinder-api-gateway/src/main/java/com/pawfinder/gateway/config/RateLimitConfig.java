package com.pawfinder.gateway.config;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.ratelimit.KeyResolver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Configuration
public class RateLimitConfig {

    @Bean
    public KeyResolver userKeyResolver() {
        return exchange -> {
            var principal = exchange.getPrincipal()
                    .map(p -> p.getName())
                    .defaultIfEmpty("anonymous");
            var address = Mono.just(
                    exchange.getRequest().getRemoteAddress() != null
                            ? exchange.getRequest().getRemoteAddress().getAddress().getHostAddress()
                            : "unknown");
            return principal.zipWith(address)
                    .map(tuple -> tuple.getT1() + ":" + tuple.getT2());
        };
    }

    @Bean
    public GatewayFilter generalRateLimitFilter() {
        return createRateLimitFilter(100, Duration.ofMinutes(1));
    }

    @Bean
    public GatewayFilter authRateLimitFilter() {
        return createRateLimitFilter(10, Duration.ofMinutes(1));
    }

    @Bean
    public GatewayFilter alertCreationRateLimitFilter() {
        return createRateLimitFilter(5, Duration.ofMinutes(1));
    }

    private GatewayFilter createRateLimitFilter(int capacity, Duration duration) {
        Map<String, Bucket> cache = new ConcurrentHashMap<>();

        return (exchange, chain) -> {
            var key = extractKey(exchange);
            Bucket bucket = cache.computeIfAbsent(key, k -> createBucket(capacity, duration));

            if (bucket.tryConsume(1)) {
                return chain.filter(exchange);
            }

            exchange.getResponse().setStatusCode(HttpStatus.TOO_MANY_REQUESTS);
            return exchange.getResponse().setComplete();
        };
    }

    private Bucket createBucket(int capacity, Duration duration) {
        return Bucket.builder()
                .addLimit(Bandwidth.classic(capacity, Refill.intervally(capacity, duration)))
                .build();
    }

    private String extractKey(ServerWebExchange exchange) {
        var principal = exchange.getPrincipal().map(p -> p.getName()).blockOptional().orElse("anonymous");
        var address = exchange.getRequest().getRemoteAddress() != null
                ? exchange.getRequest().getRemoteAddress().getAddress().getHostAddress()
                : "unknown";
        return principal + ":" + address;
    }
}
