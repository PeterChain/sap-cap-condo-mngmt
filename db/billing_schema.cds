using { cuid, managed, Currency } from '@sap/cds/common';

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