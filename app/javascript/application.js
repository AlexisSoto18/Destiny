// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import interactionPlugin from "@fullcalendar/interaction";
import "@fortawesome/fontawesome-free/css/all.css";

document.addEventListener("DOMContentLoaded", function () {
  var calendarEl = document.getElementById("calendar");

  if (calendarEl) {
    var calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
      initialView: "dayGridMonth",
      events: "/schedules.json", // Asegúrate de que esta ruta devuelva eventos en formato JSON
      selectable: true,
      dateClick: function (info) {
        let fechaInput = document.getElementById("fecha_hora_picker");
        if (fechaInput) {
          fechaInput.value = info.dateStr + "T12:00"; // Agregamos una hora predeterminada
        }
      },
    });

    calendar.render();
  }
});
