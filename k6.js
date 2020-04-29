import http from 'k6/http';
import { sleep } from 'k6';
export let options = {
  vus: VUS,
  duration: '2s',
};

export default function() {
  http.get('http://php-bench:8080/test.php');
};
