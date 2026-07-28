import { visit } from "@ember/test-helpers";
import { test } from "qunit";
import { acceptance } from "discourse/tests/helpers/qunit-helpers";

acceptance("Practice Matching | maintenance mode", function (needs) {
  needs.user({ username: "current-user" });

  needs.pretender((server, helper) => {
    server.get("/api/practice-matching", () =>
      helper.response({
        practice_interests: [],
        practice_matches: [],
        deprecated: true,
        read_only: true,
        replacement_url: "/where-is-my-friends/interests",
      })
    );
  });

  test("shows the replacement flow on the legacy page", async function (assert) {
    await visit("/practice-matching");

    assert.dom(".practice-matching-deprecation").exists();
    assert
      .dom(".practice-matching-deprecation a")
      .hasAttribute("href", "/where-is-my-friends/interests");
    assert.dom("[data-test-practice-matching-read-only]").exists();
    assert.dom("[data-test-add-practice-interest]").doesNotExist();
    assert.dom("[data-test-remove-practice-interest]").doesNotExist();
  });
});
