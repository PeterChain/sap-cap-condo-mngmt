const cds = require('@sap/cds')
const { lastDayOfMonth, 
        compareAsc, 
        differenceInMonths,
        areIntervalsOverlapping,
        format
    } = require('date-fns')


module.exports = (srv) => {
    /**
     * Validations to tenant removal
     */
    srv.before ('DELETE', 'Tenant', async (req) => {
        const tenant = req.data.ID

        //Connects to the service (in our case, it's just database service)
        const db = await cds.connect.to('db')
        const { Rent } = db.entities('pt.condo.rent')

        //Starts a transaction
        const tx = db.tx(req)
        rows = await tx.run(SELECT.from(Rent).columns('ID').where({ 'tenant_ID': tenant }))

        if (rows.length >= 1)
            req.reject(412, `Tenant with ID ${tenant} already has a rent history`)
            
    })

    /**
     * Validation to a new rent
     */
    srv.before('CREATE', 'Rent', (req) => {
        const rent = req.data

        const rentFrom = new Date(rent.rentFrom)
        const rentTo = new Date(rent.rentTo)

        // Check if data range is a valid one
        if (compareAsc(rentFrom, rentTo) >= 0)
            return req.error(400, "Renting end date can't be earlier than start date")
        
        // A rent must be at least 2 months
        if (differenceInMonths(rentFrom, rentTo) >= 0 &&
            differenceInMonths(rentFrom, rentTo) < 2)
            return req.error(400, "Renting period must be 2 months or more")

        // The fraction must be free for that time period
        const query = SELECT.from(Rent).where({'fraction': rent.fraction})
        cds.run(query).then(rents => {
            for (let existingRent of rents) {
                const existingRentFrom = new Date(existingRent.rentFrom), 
                      existingRentTo = new Date(existingRent.rentTo)
                
                if (areIntervalsOverlapping({start: rentFrom, end: rentTo},
                                            {start: existingRentFrom, end: existingRentTo}))
                    return req.error(400, "There is a rent for that period of time")
            }
        })
    })

    /**
     * Adjust fields to rent creation
     */
    srv.on('CREATE', 'Rent', (req, next) => {
        const rent = req.data

        const rentFrom = new Date(rent.rentFrom)
        const rentTo = new Date(rent.rentTo)
        
        //A rent must be set to the first day of the starting month and last of ending month
        if (rentFrom.getDay() != 1)
            rentFrom.setDate(1)
        
        if (rentTo === lastDayOfMonth(rentTo))
            rentTo = lastDayOfMonth(rentTo)
        
        req.data.rentFrom = format(rentFrom, "yyyy-MM-dd")
        req.data.rentTo = format(rentTo, "yyyy-MM-dd")

        next()    
    })
}