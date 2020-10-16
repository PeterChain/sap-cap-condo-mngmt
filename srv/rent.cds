using { pt.condo.rent as rent } from '../db/rent_schema';
using { pt.condo.billing as billing } from '../db/billing_schema';

// Rent and tenants administration
service RentManagement @( path: '/rentAdmin' )
{
    @odata.draft.enabled
    entity Tenant as projection on rent.Tenant 
        excluding {createdAt, createdBy, modifiedAt, modifiedBy};

    entity Rent as projection on rent.Rent {
        *, 
        status: redirected to RentingStatus,
        fraction: redirected to Fractions
    };    

    @readonly
    entity RentingStatus as projection on rent.RentingStatus;

    @readonly
    entity Fractions as projection on rent.Fractions;

    @readonly
    entity PaymentHistory as projection on billing.PaymentHistory;
}

service CustomerService @( path: '/customer')
{
    @capabilities: {
       Insertable:false,
       Deletable:false 
    }
    entity Tenant as projection on rent.Tenant 
        excluding {createdAt, createdBy, modifiedAt, modifiedBy};
    
    @readonly
    entity Rent as projection on rent.Rent;

    @readonly
    entity PaymentHistory as projection on billing.PaymentHistory;
}