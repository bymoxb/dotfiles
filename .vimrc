" -----------------------
" CONFIGURACIÓN GENERAL
" -----------------------
syntax on                " Activa el resaltado de sintaxis
set number               " Muestra números de línea
set relativenumber       " Números relativos (útil para moverse con j/k)
set showcmd              " Muestra comandos mientras los escribes
set cursorline           " Resalta la línea del cursor
set mouse=a              " Habilita el uso del mouse en todos los modos
set showmode             " Muestra el modo actual (INSERT, VISUAL, etc.)
set ruler                " Muestra la posición del cursor (línea, columna)

" -----------------------
" APARIENCIA
" -----------------------
set background=dark      " Mejor con temas de terminal oscuros
colorscheme desert       " Tema de colores básico incluido en Vim

" -----------------------
" BÚSQUEDA
" -----------------------
set ignorecase           " Ignora mayúsculas al buscar
set smartcase            " Pero respeta mayúsculas si las usas
set incsearch            " Muestra resultados de búsqueda mientras escribes
set hlsearch             " Resalta resultados de búsqueda

" -----------------------
" ARCHIVOS
" -----------------------
set nobackup             " No guardar archivos ~ de respaldo
set nowritebackup        " No guardar backup antes de escribir
set noswapfile           " No crear archivos .swp

" Limpiar búsqueda con Enter
nnoremap <silent> <CR> :nohlsearch<CR><CR>

