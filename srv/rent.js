const cds = require('@sap/cds')
const { lastDayOfMonth, eachMonthOfInterval, compareAsc, differenceInMonths } = require('date-fns')


module.exports = srv => {
    const db = cds.connect.to('db')
    const { Tenant, Rent } = db.entities

    /**
     * Validations to tenant removal
     */
    srv.before ('DELETE', 'Tenant', (req) => {
        const tenant = req.data.ID
        const tx = cds.transaction(req)

        return tx.run(SELECT.from(Rent).where({ tenant_ID: tenant }))
            .then(rows => {
                if (rows.length >= 1)
                    req.error(409, `Tenant with ID ${tenant} already has a rent history`)
            })
            
    })

    srv.before('CREATE', 'Rent', (req) => {
        const rent = req.data
        const tx = cds.transaction(req)

        console.log(rent)


        // Check if data range is a valid one
        if (compareAsc(rent.rentFrom, rent.rentTo) >= 0)
            return req.reject("Renting end date can't be earlier than start date")
        
        req.error(500, "For testing purposes")
        return
        
        // A rent must be at least 2 months
        if (differenceInMonths(rent.rentFrom, rent.rentTo) < 2)
            return req.reject("Renting period must be 2 months or more")
        
        // The fraction must be free for that time period
        return tx.run(SELECT.from(Rent)
                        .where('fraction =', rent.fraction)
                        .and('rentFrom >=', rent.rentFrom)
                        .or('rentTo <=', rent.rentTo)).then(rows => {
                            console.log(rows)
                            req.error(500, "For testing purposes")
                        })
    })

    // /**
    //  * Restriction on rent
    //  */
    // srv.on('CREATE', 'Rent', (req) => {
    //     const rent = req.data
        
    //     //A rent must be set to the first day of the starting month and last of ending month
    //     if (rent.validFrom.getDay() != 1)
    //         rent.validFrom.setDate(1)
        
    //     if (rent.validTo === lastDayOfMonth(rent.validTo))
    //         rent.validTo = lastDayOfMonth(rent.validTo)
        
    // })
}