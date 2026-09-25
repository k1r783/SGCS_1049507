document.addEventListener('DOMContentLoaded', function () {
    var alerts = document.querySelectorAll('.alert');

    alerts.forEach(function (alertBox) {
        alertBox.setAttribute('role', 'alert');
    });
});

