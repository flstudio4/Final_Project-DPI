"use strict";

// Function to scroll to the bottom of the chat
function scrollToBottom() {
    var messagesContainer = document.querySelector('.card-body');
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

// Scroll to the bottom when Turbo loads the page
document.addEventListener('turbo:load', scrollToBottom);

// MutationObserver to detect when new messages are added and scroll to bottom
var observer = new MutationObserver(function (mutations) {
    mutations.forEach(function (mutation) {
        if (mutation.addedNodes.length) {
            scrollToBottom();
        }
    });
});

// Start observing the target node for configured mutations
observer.observe(document.getElementById('messages'), {childList: true, subtree: true});

// Disconnect the observer when it's no longer needed to prevent memory leaks
function disconnectObserver() {
    observer.disconnect();
}


document.addEventListener('turbo:load', function () {
    const textarea = document.querySelector('.chat-textarea');

    function resizeTextarea() {
        textarea.style.height = '0'; // Reset the height
        textarea.style.height = textarea.scrollHeight + 'px'; // Set new height
    }

    function resetTextareaHeight() {
        textarea.style.height = ''; // Reset to default CSS height
    }

    // Attach the event listener
    if (textarea) {
        textarea.addEventListener('input', resizeTextarea);
        resizeTextarea(); // Adjust for initial content
    }

    // Adjusting the form submission logic
    const messageForm = document.getElementById('new_message_form');
    if (messageForm) {
        messageForm.addEventListener('submit', function () {
            // After successful message send, reset the textarea
            resetTextareaHeight();

        });
    }
});

