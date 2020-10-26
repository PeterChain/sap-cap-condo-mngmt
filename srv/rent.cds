using { pt.condo.rent as rent } from '../db/rent_schema';
using { pt.condo.billing as billing } from '../db/billing_schema';

// Rent and tenants administration
service RentManagement @( path: '/rentAdmin' )
{
    @odata.draft.enabled
    entity Tenant as projection on rent.Tenant {
        *, rents: redirected to TenantRents
    } excluding {createdAt, createdBy, modifiedAt, modifiedBy};

    @odata.draft.enabled
    entity Rent as projection on rent.Rent {
        *,
        fraction: redirected to Fractions,
        payments: redirected to PaymentHistory
    };

    @readonly
    entity RentingStatus as projection on rent.RentingStatus;

    @readonly
    entity Fractions as projection on rent.Fractions;

    @readonly
    entity TenantRents as projection on rent.TenantRents;

    @readonly
    entity PaymentHistory as projection on billing.PaymentHistory {
        *, rent: redirected to Rent
    };
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