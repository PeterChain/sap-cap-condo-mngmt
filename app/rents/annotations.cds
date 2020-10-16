using RentManagement as service from '../../srv/rent';

annotate service.Rent with @(
    Capabilities: {
        Insertable: false,
        Updatable: false,
        Deletable: false
    },
    UI: {
        LineItem: [
            {Value: fraction.fraction},
            {Value: paidPeriod},
            {Value: monthlyRent},
            {Value: rentFrom},
            {Value: rentTo},
            {Value: status.description}
        ],

        Identification: [
            {Value: fraction.fraction},
            {Value: rentFrom},
            {Value: rentTo}
        ],

        Facets: [
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>RentValues}', Target: '@UI.FieldGroup#RentValues'},
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Tenant}', Target: '@UI.FieldGroup#Tenant'}
        ],

        FieldGroup#RentValues: {
			Data: [
				{Value: monthlyRent},
				{Value: rentCurrency},
				{Value: paidPeriod}
			]
		},

        FieldGroup#Tenant: {
			Data: [
				{Value: tenant}
			]
		}
        
    }
);