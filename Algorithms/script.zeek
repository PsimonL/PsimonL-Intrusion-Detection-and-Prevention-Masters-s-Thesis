event zeek_init() {
    Log::write(Log::ID, [$ts=network_time(), $msg="Zeek ML Engine initialized"]);
}
