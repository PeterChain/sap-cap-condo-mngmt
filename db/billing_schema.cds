using { cuid, managed, Currency } from '@sap/cds/common';
using { pt.condo.rent as rentMngmt } from './rent_schema'; 

namespace pt.condo.billing;

type InvoiceStatus : Integer enum {
    due = 1;             //Invoice awayting payment
    payed = 2;           //Invoice payed
    reversed = 3;        //Invoiced has been reversed
}

entity Invoice : cuid {
    fiscalNumber : String(20);
    postDate : Date;
    dueDate : Date;
    totalAmount : Decimal(9,2);
    taxAmount : Decimal(9,2);
    status : InvoiceStatus;
    items : Composition of many InvoiceItems on items.invoice = $self;
}

entity InvoiceItems : cuid {
    invoice : Association to one Invoice;
    itemNumber : Integer;
    itemDetail : String(40);
    itemValue : Decimal(9,2);
    itemTax : Decimal(9,2);
}

// Payments performed under a rent period for a fraction
entity PaymentHistory : cuid {
    paymentDate : Date;
    payedAmount : Decimal(9,2);
    payedCurrency : Currency;
    rent : Association to one rentMngmt.Rent;
    invoice : Composition of one Invoice;
}

define view OpenInvoices 
    as select * from Invoice where status = '1';

define view OverdueInvoices
    as select * from Invoice
        where status = '1'
          and dueDate > $now;