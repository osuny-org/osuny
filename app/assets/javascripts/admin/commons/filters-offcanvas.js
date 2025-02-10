/* global */
window.osuny.filtersOffcanvas = {
    init: function () {
        'use strict';
        this.element = document.querySelector('#filtersOffcanvas');
        if (this.element === null) {
            return;
        }
        this.firstInput = this.element.querySelector('input');
        this.element.addEventListener('shown.bs.offcanvas', this.onShown.bind(this));
    },

    onShown: function () {
        'use strict';
        this.firstInput.focus();
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke().init();
