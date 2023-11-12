"use strict";

document.addEventListener('turbo:submit-end', (event) => {
    if (event.detail.success) {
        const form = document.getElementById('new_message_form');
        if (form) {
            form.reset();
        }
    }
});