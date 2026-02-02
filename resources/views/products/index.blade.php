<x-app-layout>
    <x-slot name="header">
        <div class="flex justify-between items-center">
            <h2 class="font-bold text-2xl text-gray-800">
                {{ Auth::check() ? 'Gerenciador de Produtos' : 'Nossa Vitrine' }}
            </h2>
            @auth
                <!-- Botão Novo Produto estilo Breeze -->
                <a href="{{ route('products.create') }}" class="inline-flex items-center px-4 py-2 bg-blue-500 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-blue-600 transition ease-in-out duration-150 shadow-sm">
                    <svg class="w-4 h-4 me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                    Novo Produto
                </a>
            @endauth
        </div>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">

            <!-- ALERTA VERDE DE SUCESSO -->
            @if (session('success'))
                <div id="success-alert" class="mb-6 flex items-center bg-green-500 text-white text-sm font-bold px-4 py-3 rounded-lg shadow-lg">
                    <svg class="w-4 h-4 me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                    <p>{{ session('success') }}</p>
                </div>
                <script>setTimeout(() => { document.getElementById('success-alert')?.remove(); }, 4000);</script>
            @endif

            <!-- FILTROS -->
            <div class="mb-8 p-4 bg-white rounded-xl shadow-sm border border-gray-100">
                <form method="GET" action="{{ route('products.index') }}" class="flex flex-wrap gap-4 items-end">
                    <div class="flex-1 min-w-[200px]">
                        <label class="block text-[10px] font-black text-gray-400 uppercase mb-1">Pesquisar</label>
                        <input type="text" name="search" value="{{ request('search') }}" placeholder="Nome do produto..." class="w-full border-gray-200 rounded-lg focus:ring-gray-500 focus:border-gray-500">
                    </div>
                    @auth
                        <div>
                            <label class="block text-[10px] font-black text-gray-400 uppercase mb-1">Estoque Mín.</label>
                            <input type="number" name="min_stock" value="{{ request('min_stock') }}" class="border-gray-200 rounded-lg w-24 focus:ring-gray-500">
                        </div>
                    @endauth
                    <button type="submit" class="bg-blue-500 text-white px-6 py-2 rounded-lg font-semibold text-xs uppercase tracking-widest h-[42px] hover:bg-blue-600 transition flex items-center shadow-sm">
                        <svg class="w-4 h-4 me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                        Pesquisar
                    </button>
                </form>
            </div>

            @auth
                <!-- SELETOR DE ABAS -->
                <div class="flex border-b border-gray-200 mb-6">
                    <button onclick="switchTab('tab-admin')" id="btn-admin" class="px-6 py-2 font-bold text-sm uppercase tracking-widest border-b-2 border-blue-600 text-blue-600 transition-all">
                        📋 Gerenciamento
                    </button>
                    <button onclick="switchTab('tab-vitrine')" id="btn-vitrine" class="px-6 py-2 font-bold text-sm uppercase tracking-widest border-b-2 border-transparent text-gray-500 hover:text-gray-700 transition-all">
                        🛍️ Visualizar Vitrine
                    </button>
                </div>
            @endauth

            <!-- CONTEÚDO 1: TABELA ADMINISTRATIVA -->
            <div id="tab-admin" class="{{ Auth::check() ? '' : 'hidden' }}">
                <div class="bg-white overflow-hidden shadow-sm rounded-xl border border-gray-200">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50 text-[10px] font-black text-gray-400 uppercase">
                            <tr>
                                <th class="px-6 py-3 text-left">Foto</th>
                                <th class="px-6 py-3 text-left">Produto</th>
                                <th class="px-6 py-3 text-left">Preço</th>
                                <th class="px-6 py-3 text-left">Estoque</th>
                                <th class="px-6 py-3 text-center">Ações</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200 bg-white text-sm">
                            @foreach ($products as $product)
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="px-6 py-4">
                                        <img src="{{ $product->image_url ? asset('storage/' . $product->image_url) : 'https://placehold.co/100x100?text=Sem+Foto' }}" class="w-10 h-10 object-cover rounded-lg border shadow-sm">
                                    </td>
                                    <td class="px-6 py-4 font-bold text-gray-900">{{ $product->name }}</td>
                                    <td class="px-6 py-4 text-gray-600 font-medium">R$ {{ number_format($product->price, 2, ',', '.') }}</td>
                                    <td class="px-6 py-4">
                                        <span class="px-2 py-0.5 rounded text-[10px] font-black {{ $product->stock < 10 ? 'bg-red-100 text-red-600' : 'bg-green-100 text-green-600' }}">
                                            {{ $product->stock }} UN
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <!-- GRUPO DE BOTÕES CORRIGIDO -->
                                        <div class="inline-flex shadow-sm rounded-md" role="group">
                                            <a href="{{ route('products.edit', $product) }}" class="inline-flex items-center px-3 py-2 text-[10px] font-bold text-gray-700 bg-white border border-gray-200 rounded-l-lg hover:bg-gray-50 hover:text-blue-600 focus:z-10 focus:ring-2 focus:ring-blue-500 transition">
                                                EDIT
                                            </a>
                                            <form action="{{ route('products.destroy', $product) }}" method="POST" onsubmit="return confirm('Excluir?')">
                                                @csrf @method('DELETE')
                                                <button type="submit" class="inline-flex items-center px-3 py-2 text-[10px] font-bold text-gray-700 bg-white border-t border-b border-r border-gray-200 rounded-r-lg hover:bg-gray-50 hover:text-red-600 focus:z-10 focus:ring-2 focus:ring-red-500 transition">
                                                    DELETE
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- CONTEÚDO 2: VITRINE DE CARDS (STYLE-INLINE PARA SEGURANÇA) -->
            <div id="tab-vitrine" class="{{ Auth::check() ? 'hidden' : '' }} py-4">
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 25px;">
                    @foreach ($products as $product)
                        <div style="background: white; border-radius: 15px; border: 1px solid #e5e7eb; overflow: hidden; display: flex; flex-direction: column; box-shadow: 0 1px 3px rgba(0,0,0,0.1); transition: 0.3s;">
                            <div style="width: 100%; height: 180px; background-color: #f9fafb; border-bottom: 1px solid #f3f4f6;">
                                <img src="{{ $product->image_url ? asset('storage/' . $product->image_url) : 'https://placehold.co/400x300?text=Sem+Foto' }}" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                            <div style="padding: 15px; flex: 1;">
                                <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 8px;">
                                    <h4 style="font-weight: 800; color: #111827; text-transform: uppercase; font-size: 11px; margin: 0; overflow: hidden; text-overflow: ellipsis;">{{ $product->name }}</h4>
                                    <span style="color: #2563eb; font-weight: 900; font-size: 14px; white-space: nowrap; margin-left: 10px;">R$ {{ number_format($product->price, 2, ',', '.') }}</span>
                                </div>
                                <p style="color: #6b7280; font-size: 10px; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">{{ $product->description }}</p>
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>

            <!-- PAGINAÇÃO -->
            <div class="mt-8">
                {{ $products->links() }}
            </div>
        </div>
    </div>

    <!-- SCRIPT PARA ALTERNAR ABAS -->
    <script>
        function switchTab(tabId) {
            document.getElementById('tab-admin').classList.add('hidden');
            document.getElementById('tab-vitrine').classList.add('hidden');
            document.getElementById(tabId).classList.remove('hidden');

            const btnAdmin = document.getElementById('btn-admin');
            const btnVitrine = document.getElementById('btn-vitrine');

            if(tabId === 'tab-admin') {
                btnAdmin.className = "px-6 py-2 font-bold text-sm uppercase tracking-widest border-b-2 border-blue-600 text-blue-600 transition-all";
                btnVitrine.className = "px-6 py-2 font-bold text-sm uppercase tracking-widest border-b-2 border-transparent text-gray-500 hover:text-gray-700 transition-all";
            } else {
                btnVitrine.className = "px-6 py-2 font-bold text-sm uppercase tracking-widest border-b-2 border-blue-600 text-blue-600 transition-all";
                btnAdmin.className = "px-6 py-2 font-bold text-sm uppercase tracking-widest border-b-2 border-transparent text-gray-500 hover:text-gray-700 transition-all";
            }
        }
    </script>
</x-app-layout>
