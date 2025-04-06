document.addEventListener("DOMContentLoaded", function() {
  setTimeout(function() {
    const flashMessage = document.getElementById("flash-message");
    if (flashMessage) {
      flashMessage.style.transition = "opacity 0.5s";
      flashMessage.style.opacity = "0";
      setTimeout(() => flashMessage.remove(), 500);
    }
  }, 5000);
});