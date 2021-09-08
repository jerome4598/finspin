var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        if (mutation.type === 'childList') {
            Array
                .from(mutation.addedNodes)
                .filter(function(node) {
                    return node.tagName === 'svg';
                })
                .forEach(function(node) {
                    node.addEventListener('click', function(event) {
                        var rect = event.currentTarget.getBoundingClientRect();
                        var svgClickEvent = new CustomEvent('svgclick', {
                            detail: {
                                x: event.clientX - rect.left,
                                y: event.clientY - rect.top
                            }
                        });
                        event.currentTarget.dispatchEvent(svgClickEvent);
                    });
                });
        }
    });
});

observer.observe(document.body, {
    childList: true,
    subtree: true
});
const app = Elm.Main.init({
    node: document.getElementById('note')
})

app.ports.storeNotes.subscribe(function(notes) {
    var notesJson = JSON.stringify(notes);
    localStorage.setItem('note-app-save', notesJson);
    let fileStore = localStorage.getItem('note-app-save');
    app.ports.receiveData.send(fileStore);
});
//Init load
let fileStore = localStorage.getItem('note-app-save');
app.ports.receiveData.send(fileStore);