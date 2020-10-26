using RentManagement as service from '../../srv/rent';

// List annotations
annotate service.Tenant with @(
    UI: {
        SelectionFields: [name, surname, taxNumber],
        LineItem: [
            { Value: name },
            { Value: surname },
            { Value: mail },
            { Value: mobile },
        ],

        HeaderInfo: {
            TypeName: '{i18n>Tenant}', TypeNamePlural: '{i18n>Tenants}',
			Title: {
				Value: name
			},
			Description: {Value: surname}
        },

        Identification: [ 
			{Value: name},
			{Value: surname}
		],

        Facets: [
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>General}', Target: '@UI.FieldGroup#General'},
            {$Type: 'UI.ReferenceFacet', Label: '{i18n>Rents}', Target: 'rents/@UI.LineItem'}
        ],

        FieldGroup#General: {
			Data: [
				{Value: mail},
				{Value: mobile},
				{Value: taxNumber}
			]
		}
    }
);

annotate service.TenantRents with @(
    UI: {
        LineItem: [
            {Value: fraction.fraction},
            {Value: paidPeriod},
            {Value: rentFrom},
            {Value: rentTo},
            {Value: status.description}
        ]        
    }
);