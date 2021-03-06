#property copyright "Bogdan Guban"
#property link      ""
#property version   "1.00"

class Cots{
  public:
  datetime date[];
  int com_long[];
  int com_short[];
  int com_net[];
  int non_com_long[];
  int non_com_short[];
  int non_com_net[];
  int non_rep_long[];
  int non_rep_short[];
  int non_rep_net[];
  int oi[];
  int size;
  string tool;
  
  Cots(string tool);
  ~Cots();
  
  double com_index(datetime for_time, int weeks);
  double non_com_index(datetime for_time,int weeks);
  double non_rep_index(datetime for_time,int weeks);
  double index(int &net[], datetime for_time, int weeks);
  
  double oi_index(int &arr[], datetime for_time, int weeks);
  int time_to_index(datetime time);
  
  private:
  
  int lines_number();
  string file_name();
  int load_cots();
};

int Cots::time_to_index(datetime time){
  int week_seconds = 7 * 24 * 60 * 60;
  datetime last = this.date[0];
  int i = (last - time) / week_seconds;
  int idx = i >= this.size ? this.size - 1 : i;
  return idx < 0 ? 0 : idx;
}

double Cots::index(int &net[], datetime for_time,int weeks){
  int start = this.time_to_index(for_time);
  if(start >= this.size){
    return -1;
  }
  
  int length = this.size - start < weeks ? this.size - start : weeks;
  
  int max_i = ArrayMaximum(net, start, length);
  int min_i = ArrayMinimum(net, start, length);
  
  if(net[max_i] == net[min_i]){
    return 0;
  }

  return ((double)net[start] - net[min_i]) / (net[max_i] - net[min_i]);
}

double Cots::oi_index(int &arr[], datetime for_time, int weeks){
  int start = this.time_to_index(for_time);
  if(start >= this.size){
    return -1;
  }
  
  int length = this.size - start < weeks ? this.size - start : weeks;
  double raw[];
  ArrayResize(raw, length);
  for(int i = 0; i < length; i++){
    int c = i + start;
    int sum = this.com_long[c] + this.com_short[c] + this.non_com_long[c] + this.non_com_short[c] + this.non_rep_long[c] + this.non_rep_short[c];
    if(sum == 0){
      return -1;
    }
    raw[i] = ((double)arr[c]) / sum;
  }
  
  int max_i = ArrayMaximum(raw, 0, length);
  int min_i = ArrayMinimum(raw, 0, length);
  
  if(raw[max_i] == raw[min_i]){
    return 0;
  }

  return (raw[0] - raw[min_i]) / (raw[max_i] - raw[min_i]);
}

double Cots::com_index(datetime for_time,int weeks){
  return this.index(this.com_net, for_time, weeks);
}

double Cots::non_com_index(datetime for_time,int weeks){
  return this.index(this.non_com_net, for_time, weeks);
}

double Cots::non_rep_index(datetime for_time,int weeks){
  return this.index(this.non_rep_net, for_time, weeks);
}

Cots::Cots(string tool){
  this.tool = tool;
  this.size = this.lines_number();
  this.load_cots();
}

int Cots::load_cots(void){
  ArrayResize(this.date, this.size);
  
  ArrayResize(this.oi, this.size);
  
  ArrayResize(this.com_long, this.size);
  ArrayResize(this.com_short, this.size);
  ArrayResize(this.com_net, this.size);
  
  ArrayResize(this.non_com_long, this.size);
  ArrayResize(this.non_com_short, this.size);
  ArrayResize(this.non_com_net, this.size);
    
  ArrayResize(this.non_rep_long, this.size);
  ArrayResize(this.non_rep_short, this.size);
  ArrayResize(this.non_rep_net, this.size);
  
  // reading COT data
  int f = FileOpen(this.file_name(), FILE_READ | FILE_ANSI | FILE_CSV, ",");
  if(f == INVALID_HANDLE){
    Alert("Ошибка открытия файла");
    return -1;
  }
  int i = 0;
  while(!FileIsEnding(f)){
    this.date[i] = StringToInteger(FileReadString(f));
    
    this.oi[i] = StringToInteger(FileReadString(f));
    
    this.com_long[i] = StringToInteger(FileReadString(f));
    this.com_short[i] = StringToInteger(FileReadString(f));
    this.com_net[i] = this.com_long[i] - this.com_short[i];
    
    this.non_com_long[i] = StringToInteger(FileReadString(f));
    this.non_com_short[i] = StringToInteger(FileReadString(f));
    this.non_com_net[i] = this.non_com_long[i] - this.non_com_short[i];
    
    this.non_rep_long[i] = StringToInteger(FileReadString(f));
    this.non_rep_short[i] = StringToInteger(FileReadString(f));
    this.non_rep_net[i] = this.non_rep_long[i] - this.non_rep_short[i];

    if(!FileIsLineEnding(f)){
      Alert("Looks like wrong input file format");
      return -1;
    }
    i++;
  }
  FileClose(f);
  
  return i;
}

string Cots::file_name(){
  return "/cot/" + this.tool + ".csv";
}

int Cots::lines_number(){
  int f = FileOpen(this.file_name(), FILE_READ|FILE_ANSI);
  if(f == INVALID_HANDLE){
    Alert("Ошибка открытия файла " + file_name());
    return -1;
  }
  int count = 0;
  while(!FileIsEnding(f)){
    FileReadString(f);
    count++;
  }
  FileClose(f);
  return count;
}

Cots::~Cots(){
}
