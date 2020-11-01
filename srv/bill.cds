using { pt.condo.billing as billing } from '../db/billing_schema';
using { pt.condo.rent as rent } from '../db/rent_schema';


// Invoicing services
service BillingService @( path: '/billing' )
{
    entity Invoice as projection on billing.Invoice;

    entity InvoiceItems as projection on billing.InvoiceItems {
        *, invoice: redirected to Invoice
    };

    @readonly
    entity OpenInvoices as projection on billing.OpenInvoices;

    @readonly
    entity OverdueInvoices as projection on billing.OverdueInvoices;

    function getPDF (invoice: String) returns String;
}
