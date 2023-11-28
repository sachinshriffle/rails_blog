import "@hotwired/turbo-rails"
import "controllers"
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

document.addEventListener("DOMContentLoaded", () => {
  if (document.querySelector(".chat")) {
    window.chat = new Chat();
  }
});