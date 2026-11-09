---
ia-translate: true
title: "Experimentando Dart e Wasm"
description: "Compilando Dart para Wasm e chamando módulos Wasm a partir do Dart"
publishDate: 2021-07-27
author: mit-mit
image: images/1UqHnD9vyTvndgJpz8gOv7Q.webp
category: other
layout: blog
---


*Por Liam Appelbe e Michael Thomsen*

O [WebAssembly](https://webassembly.org/) (comumente abreviado para Wasm) é *“um formato de instrução binário para uma máquina virtual baseada em pilha”.* Embora o Wasm tenha sido originalmente projetado para executar código nativo na web, ele evoluiu para uma tecnologia geral para executar código compilado em múltiplas plataformas. O Dart já é uma linguagem altamente portável e multiplataforma, então estamos muito interessados em como o Wasm pode nos permitir estender essas qualidades do Dart.

## Por que experimentar com Wasm? {:#why-experiment-with-wasm}

O Wasm ganhou [amplo suporte](https://webassembly.org/roadmap/) dos fabricantes de navegadores, como Chrome, Edge, Firefox e WebKit. Isso torna o Wasm uma perspectiva muito interessante para executar código binário no navegador. No entanto, originalmente o Wasm não foi projetado para linguagens de programação com coleta de lixo (GC), como Dart e Java/Kotlin, o que dificulta compilar eficientemente linguagens com GC para Wasm. Ao participar do projeto Wasm na sua recente [proposta de GC](https://github.com/WebAssembly/gc/blob/master/README.md), esperamos tanto fornecer feedback técnico sobre a proposta quanto aprender mais sobre quais ganhos poderíamos obter ao executar apps web baseados em Dart via código Wasm.

Uma segunda qualidade do Wasm é que os módulos Wasm binários são independentes de plataforma. Isso potencialmente torna a interoperabilidade com código existente mais prática: se esse código existente pudesse ser compilado para Wasm, então apps Dart em todas as plataformas poderiam depender de um único módulo Wasm binário compartilhado.

No restante deste post, vamos discutir nossos experimentos com Wasm e Dart em duas formas:

1) **Compilação de Dart para Wasm**: estendendo nossos compiladores AOT com suporte a compilar código-fonte Dart para código binário Wasm (issue [32894](https://github.com/dart-lang/sdk/issues/32894)).

2) **Interop de Dart com Wasm**: suporte a chamar, a partir de código Dart, módulos Wasm compilados (issues [37355](https://github.com/dart-lang/sdk/issues/37355) e [37882](https://github.com/dart-lang/sdk/issues/37882)).

<DashImage src="images/1UqHnD9vyTvndgJpz8gOv7Q.webp" alt="Diagram comparing Dart to Wasm compilation with Dart to Wasm interop through the Dart VM runtime." caption="Illustration of the two potential uses of Wasm with Dart" />


## Compilando Dart para Wasm {:#compiling-dart-to-wasm}

Como mencionado, o Wasm surgiu como uma forma de executar código nativo na web. A web é tradicionalmente movida por código JavaScript, que roda em uma máquina virtual (VM) que realiza compilação just-in-time (JIT) do código JavaScript para código nativo enquanto o app web está em execução. Nos frameworks Dart atuais que têm a web como alvo, como o [Flutter web](https://flutter.dev/web), o código do app em Dart é compilado para [JavaScript otimizado](https://dart.dev/web/deployment) para deploy, e esse JavaScript é então compilado por JIT pela plataforma web para código nativo quando o app está rodando.

Estamos investigando a compilação de código Dart diretamente para código nativo Wasm, para ver se conseguimos um caminho mais direto para executar código nativo na web. O formato assembly do Wasm é de baixo nível e, mais do que o JavaScript, fica mais próximo do nível de abstração do código de máquina, o que leva a um tempo de inicialização melhor e, em geral, a uma eficiência mais previsível.

O suporte do Dart à compilação para Wasm é uma investigação em estágio inicial, e o compilador ainda está incompleto, mas estamos experimentando para aprender. Sempre tivemos interesse no Wasm como alvo de compilação para o Dart, mas sua forma original não funciona bem para linguagens com coleta de lixo. O Wasm não tem suporte nativo a coleta de lixo, então linguagens como o Dart precisam incluir uma implementação de GC no módulo Wasm compilado. Incluir uma implementação de GC seria altamente complexo, aumentaria o tamanho do código Wasm compilado e prejudicaria o tempo de inicialização, e não se prestaria bem à interop em nível de objeto com o restante do sistema do navegador.

Felizmente, um esforço em andamento na comunidade WebAssembly, conhecido como [Wasm GC](https://github.com/WebAssembly/gc/blob/master/README.md), está explorando a possibilidade de expandir o Wasm com suporte direto e performático a linguagens com coleta de lixo. Dado nosso interesse de longa data no Wasm, vimos uma oportunidade de engajar a comunidade e oferecer experiência do mundo real, escrevendo um compilador que traduz Dart para Wasm GC.

É cedo demais para prever aonde isso pode nos levar, mas nosso protótipo inicial está mostrando resultados muito positivos, com benchmarks iniciais mostrando tanto um tempo mais rápido até o primeiro frame quanto um tempo médio de frame / throughput melhor. Se você tem interesse em saber mais sobre o projeto, dê uma olhada no código-fonte do [wasm_prototype](https://github.com/askeksa-google/sdk/blob/wasm_prototype/dart2wasm.md).

## Interoperabilidade com código Wasm (package:wasm) {:#interoperability-with-wasm-code-package-wasm}

Além de compilar para Wasm, também temos interesse em investigar se o Wasm pode ser usado para integrar com código existente de forma mais multiplataforma. Várias linguagens oferecem suporte a compilar para módulos que seguem a convenção de chamada do C, e com o [Dart FFI](https://dart.dev/guides/libraries/c-interop) você tem interoperabilidade com esses módulos. O Dart FFI pode ser uma ótima forma de aproveitar código-fonte e bibliotecas existentes, em vez de precisar reimplementar o código em Dart.

No entanto, como módulos C são específicos de plataforma, distribuir pacotes compartilhados com módulos C nativos é complicado: exige um sistema de build universal ou a distribuição de vários módulos binários (um para cada plataforma desejada). A distribuição seria muito mais fácil se um único formato de montagem binário Wasm pudesse ser usado em todas as plataformas. Assim, em vez de compilar sua biblioteca para código binário específico de plataforma para cada plataforma-alvo, você poderia compilá-la uma única vez para um módulo binário Wasm e executá-lo em qualquer lugar. Isso poderia abrir a porta para a distribuição fácil, no [pub.dev](https://pub.dev), de pacotes que contêm código nativo.

Estamos experimentando com suporte a interop com Wasm em um novo pacote, o [`package:wasm`](https://pub.dev/packages/wasm). Este protótipo é construído sobre o runtime [Wasmer](https://wasmer.io/) e oferece suporte a [WASI](https://wasi.dev/) para interação com o sistema operacional. Observe que nosso protótipo atual é incompleto e oferece suporte apenas a plataformas desktop (Windows, Linux e macOS).

## Exemplo: chamando a biblioteca de compressão Brotli {:#example-calling-into-the-brotli-compression-library}

Vamos ver um exemplo de uso do `package:wasm` para aproveitar a [biblioteca de compressão Brotli](https://github.com/google/brotli), compilada para um módulo Wasm. No exemplo, vamos ler um arquivo de entrada, comprimi-lo, informar sua taxa de compressão e, em seguida, descomprimi-lo e verificar se obtemos a entrada de volta. Veja o repositório no GitHub para o [código-fonte completo do exemplo](https://github.com/dart-lang/wasm/tree/main/example). Como o `package:wasm` é construído sobre o [`dart:ffi`](https://dart.dev/guides/libraries/c-interop), você pode achar os passos familiares se tiver experiência com FFI.

Há algumas formas de compilar código C para Wasm, mas neste caso usamos o [wasienv](https://github.com/wasienv/wasienv). Os detalhes completos estão disponíveis no [README](https://github.com/dart-lang/wasm/blob/main/README.md).

Para este exemplo, vamos tentar chamar estas funções do Brotli para comprimir e descomprimir dados:

```
int BrotliEncoderCompress(
  int quality, int lgwin, int mode, size_t input_size,
  const uint8_t* input_buffer, size_t* output_size,
  uint8_t* output_buffer);

int BrotliDecoderDecompress(
  size_t encoded_size, const uint8_t* encoded_buffer,
  size_t* output_size, uint8_t* output_buffer);
```


Os argumentos `quality`, `lgwin` e `mode` são parâmetros de ajuste do encoder. Os detalhes não são relevantes para o exemplo, então vamos usar apenas valores padrão para eles. Outra coisa a notar é que `output_size` é um parâmetro de entrada e saída. Quando chamamos essas funções, `output_size` deve ser inicializado com o tamanho do `output_buffer` que alocamos, e depois ele será definido com a quantidade do buffer que foi de fato usada.

O primeiro passo é usar nosso binário Wasm compilado para construir um objeto `WasmModule`. Os dados binários devem ser um `Uint8List`, que podemos obter lendo o arquivo com `file.readAsBytesSync()`.

```
var brotliPath = Platform.script.resolve(‘libbrotli.wasm’);
var moduleData = File(brotliPath.path).readAsBytesSync();
var module = WasmModule(moduleData);
```


Uma ferramenta de depuração muito útil para garantir que nosso módulo Wasm tem a API que esperamos é `module.describe()`. Ela retorna uma string listando todos os imports e exports do módulo.

```
print(module.describe());
```


Para a nossa biblioteca Brotli, esta é a saída:

```
import function: int32 wasi_unstable::fd_close(int32)
import function: int32 wasi_unstable::fd_write(int32, int32, int32, int32)
import function: int32 wasi_unstable::fd_fdstat_get(int32, int32)
import function: int32 wasi_unstable::fd_seek(int32, int64, int32, int32)
import function: void wasi_unstable::proc_exit(int32)

export memory: memory
export function: int32 BrotliDecoderSetParameter(int32, int32, int32)
export function: int32 BrotliDecoderCreateInstance(int32, int32, int32)
export function: void BrotliDecoderDestroyInstance(int32)
export function: int32 BrotliDecoderDecompress(int32, int32, int32, int32)
…
export function: int32 BrotliEncoderSetParameter(int32, int32, int32)
export function: int32 BrotliEncoderCreateInstance(int32, int32, int32)
export function: void BrotliEncoderDestroyInstance(int32)
export function: int32 BrotliEncoderMaxCompressedSize(int32)
export function: int32 BrotliEncoderCompress(int32, int32, int32, int32, int32, int32, int32)

…
```


Podemos ver que o módulo importa algumas funções do WASI e exporta sua memória e várias funções do Brotli. As duas funções que nos interessam são exportadas, mas a assinatura delas parece um pouco diferente. Isso acontece porque o Wasm só suporta ints e floats de 32 e 64 bits. Os ponteiros viraram índices `int32` na memória exportada.

O próximo passo é instanciar o módulo. Durante a instanciação, precisamos preencher todos os imports que o módulo espera. A instanciação usa o padrão builder (`module.instantiate(). initialization… .build()`). Nossa biblioteca só importa funções do WASI, então podemos simplesmente chamar `enableWasi()`:

```
var instance = module.instantiate().enableWasi().build();
```


Se tivéssemos imports de funções não-WASI adicionais, poderíamos usar `addFunction()` para importar uma função Dart para a biblioteca wasm.

Agora que temos uma `WasmInstance`, podemos buscar qualquer uma de suas funções exportadas ou inspecionar sua memória:

```
var memory = instance.memory;
var compress = instance.lookupFunction(“BrotliEncoderCompress”);
var decompress = instance.lookupFunction(“BrotliDecoderDecompress”);
```


A próxima coisa que queremos fazer é usar as funções de compressão e descompressão no nosso arquivo de entrada. Mas não podemos passar os dados diretamente para essas funções. As funções em C recebem ponteiros `uint8_t` para os dados, mas no código Wasm esses ponteiros viram índices `int32` na memória da instância. O Brotli também informa o tamanho dos dados comprimidos e descomprimidos usando ponteiros `size_t`, que também viram `int32`s.

Então, para passar nossos dados para as funções, precisamos copiá-los para a memória da instância e passar o índice para a função. Precisamos de 5 regiões de memória: os dados de entrada, os dados comprimidos, o tamanho comprimido, os dados descomprimidos e o tamanho descomprimido. Para simplificar, vamos apenas pegar algumas áreas não usadas da memória, mas você também poderia exportar `malloc()` e `free()` na sua biblioteca.

Para garantir que estamos colocando os dados em memória não usada, vamos expandir a memória da instância e usar a nova região para os nossos dados:

```
var inputPtr = memory.lengthInBytes;
memory.grow((3 * inputData.length /
    WasmMemory.kPageSizeInBytes).ceil());
var memoryView = memory.view;
var outputPtr = inputPtr + inputData.length;
var outSizePtr = outputPtr + inputData.length;
var decodedPtr = outSizePtr + 4;
var decSizePtr = decodedPtr + inputData.length;
```


Nossas regiões de memória ficam assim:

```
[initial instance memory][input][output][output size][decoded][decoded size]
```


Em seguida, carregamos os dados de entrada na memória e chamamos nossa função de compressão:

```
memoryView.setRange(
    inputPtr, inputPtr + inputData.length, inputData);

var status = compress(kDefaultQuality, kDefaultWindow, kDefaultMode,
    inputData.length, inputPtr, outSizePtr, outputPtr);
```


O restante do exemplo funciona de forma parecida. Este é o resultado:

```
Loading lipsum.txt
Input size: 3210 bytes

Compressing…
Compression status: 1
Compressed size: 1198 bytes
Space saving: 62.68%

Decompressing…
Decompression status: 1
Decompressed size: 3210 bytes

Verifying decompression…
Decompression succeeded :)
```


## Testando o package:wasm {:#trying-package-wasm}

Se você tem interesse em testar a interop com Wasm, confira o [README](https://pub.dev/packages/wasm) do `package:wasm` para ver as instruções.

## Roadmap {:#roadmap}

Tanto a compilação para Wasm quanto a interop com Wasm são experimentos. Se esses experimentos se mostrarem frutíferos, planejamos continuar desenvolvendo-os e, eventualmente, transformá-los em versões estáveis e suportadas. No entanto, se descobrirmos que algo não funciona como pretendido, ou se percebermos falta de interesse, vamos descontinuar os experimentos.

Estamos fazendo esses experimentos para aprender, com dois componentes principais. Primeiro, queremos entender a viabilidade de dar suporte técnico ao Wasm e quais podem ser as características desse suporte. Ele pode tornar o código Dart mais rápido, menor ou mais previsível? Segundo, estamos interessados em explorar quais novas capacidades técnicas o Wasm pode desbloquear e quais novos casos de uso isso pode habilitar para desenvolvedores Dart. Podemos tornar a interop com código nativo mais portável?

Como você acha que o Wasm pode se aplicar às suas necessidades? Para que você o usaria? Adoraríamos ouvir a sua opinião. Conte pra gente no [grupo de discussão misc do Dart](https://groups.google.com/a/dartlang.org/g/misc/).
