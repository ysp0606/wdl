task inline {
  command<<<
    python3 <<CODE
    with open('${File path}') as fp:
      for line in fp:
        if line.startswith('zoologic'):
          print(line.strip())
    CODE
  >>>
  runtime {
    docker: docker
  }
}

task task1 {
  command {
    grep '^aberran' ${File infile}
  }
  output {
    Array[String] words_a = tsv("stdout")
    Int blah = 1+1
  }
  runtime {
    docker: docker
  }
}

task task2 {
  command {
    grep '^backbone' ${File infile}
  }
  output {
    Array[String] words_b = tsv("stdout")
  }
  runtime {
    docker: docker
  }
}

task task3 {
  command {
    grep '^xantha' ${File infile} || exit 0
  }
  output {
    Array[String] words_x = tsv("stdout")
  }
  runtime {
    docker: docker
  }
}

workflow simple {
  Array[String] array_of_str
  Array[Array[Array[File]]] scatter_files
  String docker
  String words = "w"+"o"+"r"+"d"+"s"
  File dict_file = "/usr/share/dict/" + words
  Boolean b = false

  call task1 {
    Int x = (1 + 2) * (10 - 4) * 7
    Int y = strlen("hello world") + 10 + x
    input: docker=docker, infile=dict_file
  }
  call task2 {
    input: infile=dict_file, docker=docker
  }
  call task3 as alias {
    input: infile="/usr/share/dict/" + words, docker=docker
    output: array_of_str=words_x
  }
  call inline {
    input: path=dict_file, docker=docker
  }
  while(b) {
    call task3 as alias1 {
      input: docker=docker, infile=dict_file
    }
  }
  scatter(x in scatter_files) {
    scatter(y in x) {
      scatter(z in y) {
        call task2 as alias2 {
          input: infile=z, docker=docker
        }
      }
    }
  }
}