import { module, test } from "qunit";
import practiceMatchNotificationRenderer from "discourse/plugins/discourse-plugin-matching/discourse/lib/practice-match-notification-renderer";

module("Unit | Practice match notification renderer", function () {
  class NotificationTypeBase {
    constructor(notification) {
      this.notification = notification;
    }

    get linkHref() {
      return "/core-link";
    }
  }

  const Renderer = practiceMatchNotificationRenderer(NotificationTypeBase);

  test("uses the plugin action URL for practice-match custom notifications", function (assert) {
    const renderer = new Renderer({
      data: {
        message: "practice_matching.notification.mutual_match",
        action_url: "/practice-matching",
      },
    });

    assert.strictEqual(renderer.linkHref, "/practice-matching");
  });

  test("preserves action URLs from other custom notifications", function (assert) {
    const renderer = new Renderer({
      data: {
        message: "another.plugin.notification",
        action_url: "/where-is-my-friends/interests",
      },
    });

    assert.strictEqual(
      renderer.linkHref,
      "/where-is-my-friends/interests"
    );
  });

  test("preserves core link behavior for unrelated custom notifications", function (assert) {
    const renderer = new Renderer({
      data: { message: "another.plugin.notification" },
    });

    assert.strictEqual(renderer.linkHref, "/core-link");
  });
});
