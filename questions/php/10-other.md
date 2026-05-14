## Что выведет $data['key']?

$data = ['key' => 'original'];
$ref = &$data['key'];
$copy = $data;
$copy['key'] = 'modified';
 
echo $data['key']; // Выведет 'modified'!