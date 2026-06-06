package com.pawfinder.notification.listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * Listens for notification events published to RabbitMQ
 * and dispatches them to the appropriate delivery channel.
 *
 * TODO: Implement full message routing logic
 *       - Route alert.created → push + email + optional SMS
 *       - Route reward.claimed → email confirmation
 *       - Route match.found → push notification to alert owner
 */
@Component
public class NotificationListener {

    private static final Logger log = LoggerFactory.getLogger(NotificationListener.class);

    @RabbitListener(queues = "${rabbitmq.queue.notification:pawfinder.notification.queue}")
    public void handleNotificationEvent(String message) {
        log.info("Received notification event: {}", message);
        // TODO: Parse event type, determine delivery channels, dispatch
    }
}
