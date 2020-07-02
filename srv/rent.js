const cds = require('@sap/cds')

module.exports = function() {
    // Tenant restrictions
    this.before ('DELETE', 'Tenant', (req) => {
        //TODO: Validate existence of a rent entry
    })
}