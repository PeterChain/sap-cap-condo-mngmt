using { pt.condo.rent as rent } from '../db/rent_schema';
using { pt.condo.billing as billing } from '../db/billing_schema';

// Rent and tenants administration
service RentManagement 
    @( path: '/rent' )
    // @( path: '/rent', requires: 'authenticated-user') 
{
    // @restrict: [
    //     { grant: 'READ', to: 'tenant' },
    //     { grant: ['CREATE','READ','UPDATE', 'DELETE'], to: 'admin' },
    // ]
    entity Tenant as projection on rent.Tenant 
        excluding {createdAt, createdBy, modifiedAt, modifiedBy};

    @capabilities: {
       Insertable:true, 
       Updatable:true,
       Deletable:false 
    }
    // @restrict: [
    //     { grant: 'READ', to: 'tenant' },
    //     { grant: ['READ', 'UPDATE','CREATE'], to: 'admin' },
    // ]
    entity Rent as projection on rent.Rent;
}


// Rent and additional payments administration
service BillingManagement @( path: 'billingManagement' )
{
    @readonly
    entity PaymentHistory as projection on rent.PaymentHistory;

    entity AdditionalExpenses as projection on rent.AditionalExpense;

    action issueBill (rent: String, 
                      month: Integer, 
                      year: Integer, 
                      includeAdditionals: Boolean
                    ) returns String
}


// Invoicing services
service InvoiceService {
    
    entity Invoice as projection on billing.Invoice;
}
