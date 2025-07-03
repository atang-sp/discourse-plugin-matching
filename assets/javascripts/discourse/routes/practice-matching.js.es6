export default Discourse.Route.extend({
  model() {
    return ajax("/practice-matching");
  }
}); 