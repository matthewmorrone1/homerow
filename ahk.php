<?

$wordFile = "plain.txt";
$outFile = "chars.txt";


function sortout($arr) {
	arsort($arr);
	return $arr;
}

function ref() {
	return $ref = array(
		"q" => "a",
		"z" => "a",
		"w" => "s",
		"x" => "s",
		"e" => "d",
		"c" => "d",
		"r" => "f",
		"v" => "f",
		"t" => "g",
		"b" => "g",
		"y" => "h",
		"n" => "h",
		"u" => "j",
		"m" => "j",
		"i" => "k",
		"o" => "l",
		"p" => "l",
		);
}

function words($asString) {
	global $wordFile;
	if ($asString) {
		$file = file_get_contents($wordFile);
		$file = strtolower($file);
		$file = trim($file);
		return $file;
	}
	$file = file($wordFile);
	$file = array_map("strtolower", $file);
	$file = array_map("trim", $file);
	return $file;
}

function wordsToChars() {
	$ref = ref();
	$file = words(true);

	foreach($ref as $k=>$v):
		$file1 = str_replace($k, $v, $file1);
	endforeach;

	$file2 = fopen($outFile, "w+");
	fwrite($file2, $file1);
	fclose($file2);
}

function charsInfo() {
	$chars = array_map("trim", file($outFile));

	$unis = array_unique($chars);
	// print_r(sortout($unis));

	$vals = array_count_values($chars);
	// print_r(sortout($vals));
	print_r(sortout(array_count_values($vals)));

	echo "\n\n";
	echo "C:     ".count($chars)."\n";
	echo "U:     ".count($unis)."\n";
	echo "C - U: ".(count($chars)-count($unis))."\n";
	echo "\n\n";

}


function generateMap() {
	$ref = ref();
	$file = words();



	$out = out();

	$file2 = fopen("map.txt", "w+");
	foreach($out as $k=>$v):
		fwrite($file2, "$k\t$v\n");
	endforeach;
	fclose($file2);

}


function out() {
	$file = words();
	$ref = ref();
	foreach($file as $line):
		$before = $line;
		$after = $line;
		foreach($ref as $k=>$v):
			$after = str_replace($k, $v, $after);
		endforeach;
		$out[$before] = $after;
	endforeach;
	return $out;
}


function toAHK() {
	$out = out();
	$file = fopen("map.ahk", "w+");
	foreach($out as $k=>$v):
		fwrite($file, ":*:$v::$k\n");
	endforeach;
	fclose($file);
}


function findIso() {
	$chars = array_map("trim", file("map.ahk"));
	$iso = [];
	foreach($chars as $line):
		$line = explode("::", $line);
		// echo $line[1]." ".$line[2]."\n";
		if (strcmp($line[1], $line[2]) === 0) {
			// echo $line[1]."\n";
			$iso[] = $line[1];
		}
	endforeach;
	return $iso;
}
function findUniques() {
	$chars = array_map("trim", file("map.ahk"));
	$crash = [];
	$crash2 = [];
	foreach($chars as $line):
		$line = explode("::", $line);
		$crash[$line[1]][] = $line[2];
	endforeach;
	foreach($crash as $k=>$entry):
		if (count($entry) === 1) {
			$crash2[$k] = $entry[0];
		}
	endforeach;
	return $crash2;
}
function findCollisions() {
	$chars = array_map("trim", file("map.ahk"));
	$crash = [];
	$crash2 = [];
	foreach($chars as $line):
		$line = explode("::", $line);
		$crash[$line[1]][] = $line[2];
	endforeach;
	foreach($crash as $k=>$entry):
		if (count($entry) > 1) {
			$crash2[count($entry)][strlen($k)][$k] = $entry;
		}
	endforeach;
	return $crash2;
}
function printUniques() {
	$z = findUniques();
	foreach($z as $a=>$b):
		echo "$a\t$b\n";
	endforeach;
}
function printCollisions() {
	$z = findCollisions();
	// print_r($z);
	echo "this is baroke\n";
	return;
	foreach($z as $a=>$b):
		asort($b);
		echo "\n\n\n".$a."\n\n\n";
		foreach($b as $c=>$d):
			echo $c.":\t";
			foreach($d as $e=>$f):
				echo $f."\t";
			endforeach;
			echo "\n";
		endforeach;
	endforeach;
}

function tsv2ahk() {
	$z = file("all.tsv");
	foreach($z as $a=>$b):
		$line = explode("\t", $b);
		$a = trim($line[0]);
		$b = trim($line[1]);
		echo "::$a::$b\n";
	endforeach;
}

// generateMap();
// charsInfo();
// toAHK();
// parseAHK();
// findCollisions();
// printCollisions();
// findUniques();
// printUniques();
tsv2ahk();

?>
