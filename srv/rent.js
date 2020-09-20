const cds = require('@sap/cds')
const { lastDayOfMonth, eachMonthOfInterval, compareAsc, differenceInMonths, parseISO } = require('date-fns')


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

        return tx.reject(404)

        const rentFrom = new Date(parseISO(rent.rentFrom))
        const rentTo = new Date(parseISO(rent.rentTo))

        if (rentFrom > rentTo) {
            return req.reject(400, "Renting end date can't be earlier than start date")
        }

        // Check if data range is a valid one
        try {
            if (compareAsc(rentFrom, rentTo) >= 0)
                return req.error(400, "Renting end date can't be earlier than start date")
            
            // A rent must be at least 2 months
            if (differenceInMonths(rent.rentFrom, rent.rentTo) < 2) {
                req.reject(400, "Renting period must be 2 months or more")
                return
            }
            
        } catch (e) {
            console.log("error", e)
        }
        
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