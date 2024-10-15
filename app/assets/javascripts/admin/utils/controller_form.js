window.osuny.isInControllerForm = function (controllerName) {
    'use strict';
    return document.body.classList.contains(controllerName + '-new') ||
        document.body.classList.contains(controllerName + '-edit') ||
        document.body.classList.contains(controllerName + '-create') ||
        document.body.classList.contains(controllerName + '-update');
};
