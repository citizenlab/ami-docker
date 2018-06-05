<?php
$snippets = array(
	'request_header' => '<p>{{date}}</p>
	<div ng-if="operator.meta.privacy_contact_address_1">
	   {{ operator.meta.privacy_contact_address_1 }}
	</div>
	<div ng-if="operator.meta.privacy_contact_address_2">
	   {{operator.meta.privacy_contact_address_2}}
	</div>
	<div ng-if="operator.meta.privacy_contact_city">
	   {{ operator.meta.privacy_contact_city }}<span ng-if="operator.meta.privacy_contact_province">, {{ operator.meta.privacy_contact_province }}</span>
	</div>
	<div ng-if="operator.meta.privacy_contact_postal_code">
	   {{ operator.meta.privacy_contact_postal_code }}
	</div>',
	'questions' => '<ul><li ng-repeat="componentquestion in componentquestions | filter: { selected: true }" ng-bind-html="componentquestion.data"></li></ul>',
	'data' => '<ol><li ng-repeat="data in componentdata | filter: { selected: true }" ng-bind-html="data.data"></li></ol>',
	'identifiers' => '<p>
	<div ng-repeat="(key, service) in services">
	<strong ng-if="subject.service_identifiers[service.id].length">{{service.title}}</strong>
	<ul>
	<li ng-repeat="identifier in subject.basic_personal_info | object2Array | orderBy:\'+weight\'">{{identifier.title}}: {{identifier.value}}</li>
	<li ng-repeat="identifier in subject.service_identifiers[service.id] | object2Array | orderBy:\'+weight\'">{{identifier.title}}: {{identifier.value}}</li>
	</ul>
	</div>
	</p>',
	'request_footer' => '<p><span ng-repeat="identifier in subject.basic_personal_info | object2Array | orderBy:\'+weight\'" ng-if="(identifier.title == "First Name" || identifier.title == "Prénom") || (identifier.title == "Last Name" || identifier.title == "Nom")">{{identifier.value}}<span ng-if="($first)"> </span></span></p>'
);


function ami_add_snippets($snippet_id, $snippet_content){
	$snippet_list = get_option('rhs_snippet_list');
	if ( !is_array($snippet_list) )
		$snippet_list = array();
	
	// save snippet
	$snippet_id = strtolower($snippet_id);
	$snippet_list[] = $snippet_id;
	update_option('rhs_snippet_list', $snippet_list);
	update_option('rhs_snippet-' . $snippet_id, stripslashes($snippet_content));
	$success = 'Your snippet has been saved.';
	$clean = array();
}

foreach($snippets as $snippet_id => $snippet_content){
	ami_add_snippets($snippet_id, $snippet_content);
}