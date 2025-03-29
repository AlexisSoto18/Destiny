// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';

document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');

  if (calendarEl) {
    var calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, interactionPlugin],
      initialView: 'dayGridMonth',
      events: '/schedules.json', // Asegúrate de tener esta ruta configurada en tu controlador
      dateClick: function(info) {
        alert('Fecha seleccionada: ' + info.dateStr);
      }
    });

    calendar.render();
  }
});